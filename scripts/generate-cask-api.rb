# frozen_string_literal: true

# mise が読む cask メタデータを `api/cask/<token>.json` へ生成する。
# 設計は docs/decisions/screen_saver を使わず宣言的ステップで cask を書く.md
#
#   brew ruby scripts/generate-cask-api.rb nozomiishii/tap

require "cask/cask"
require "cask/cask_loader"
require "json"

tap_name = ARGV.first
abort "usage: brew ruby #{$PROGRAM_NAME} <owner>/<tap>" if tap_name.nil? || !tap_name.include?("/")

root = Pathname(__dir__).parent
cask_paths = Pathname.glob(root/"Casks"/"**"/"*.rb").sort
abort "no casks found under #{root/"Casks"}" if cask_paths.empty?

out_dir = root/"api"/"cask"
out_dir.mkpath

Homebrew.with_no_api_env do
  # HOMEBREW_PREFIX と HOME をプレースホルダへ差し替える。cask の読み込みより先に呼ぶ
  Cask::Cask.generating_hash!

  newest_macos = MacOSVersion.new(HOMEBREW_MACOS_NEWEST_SUPPORTED).to_sym
  Homebrew::SimulateSystem.with(os: newest_macos, arch: :arm) do
    cask_paths.each do |path|
      cask = Cask::CaskLoader.load(path)
      hash = cask.to_hash_with_variations

      # 読み込み元のパスで変わる値を固定し、どこで生成しても同じ JSON にする
      hash["tap"] = tap_name
      hash["full_token"] = "#{tap_name}/#{cask.token}"
      hash["ruby_source_path"] = path.relative_path_from(root).to_s

      (out_dir/"#{cask.token}.json").write("#{JSON.pretty_generate(hash)}\n")
      puts "generated api/cask/#{cask.token}.json"
    end
  end
end
