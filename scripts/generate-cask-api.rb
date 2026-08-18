# frozen_string_literal: true

# Homebrew API 形式の cask メタデータを `api/cask/<token>.json` へ生成する。
#
#   brew ruby scripts/generate-cask-api.rb nozomiishii/tap
#
# mise の brew-cask manager は、サードパーティ tap の cask メタデータを
# `<tap の raw base>/api/cask/<token>.json` から直接取得する。homebrew/cask だけが
# formulae.brew.sh の API を使うため、tap 側でこのファイルを公開する必要がある。
#
# Homebrew 本体の `brew generate-cask-api` は CoreCaskTap 決め打ちでサードパーティ
# tap に使えないため、同じ生成経路 (`generating_hash!` + `to_hash_with_variations`)
# を自前でなぞる。`generating_hash!` が HOMEBREW_PREFIX と HOME をプレースホルダへ
# 差し替えるので、生成物はマシン非依存になる。cask の読み込みより先に呼ぶこと。
#
# 引数の tap 名は出力の正規化に使うほか、Homebrew の tap trust チェックを満たす
# (ARGV に tap 名があれば明示的に許可されたものとして扱われる)。

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
  Cask::Cask.generating_hash!

  newest_macos = MacOSVersion.new(HOMEBREW_MACOS_NEWEST_SUPPORTED).to_sym
  Homebrew::SimulateSystem.with(os: newest_macos, arch: :arm) do
    cask_paths.each do |path|
      cask = Cask::CaskLoader.load(path)
      hash = cask.to_hash_with_variations

      # tap 配下から読んだか作業コピーから読んだかで変わる値を固定し、生成元に
      # かかわらず同じ JSON になるようにする。
      hash["tap"] = tap_name
      hash["full_token"] = "#{tap_name}/#{cask.token}"
      hash["ruby_source_path"] = path.relative_path_from(root).to_s

      (out_dir/"#{cask.token}.json").write("#{JSON.pretty_generate(hash)}\n")
      puts "generated api/cask/#{cask.token}.json"
    end
  end
end
