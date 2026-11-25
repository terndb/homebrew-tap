class Terndb < Formula
  desc "Relational, ACID database with nested results, written in sysl"
  homepage "https://github.com/terndb/terndb"
  version "0.0.1"
  license "MIT"

  # TernDB is written in sysl, and its release tarball is built on the author's machine. Only macOS
  # on arm64 for now.
  depends_on arch: :arm64
  depends_on :macos

  url "https://github.com/terndb/terndb/releases/download/v#{version}/terndb-#{version}-darwin-arm64.tar.gz"
  sha256 "980f37563f61f46f9777457dbc2cb4d7a00de47c2066447efc16c8fad29f117b"

  def install
    bin.install "bin/terndb"
  end

  test do
    assert_equal "terndb #{version}\n", shell_output("#{bin}/terndb --version")

    # A round trip through the embedded shell, over an in-memory database of its own.
    sql = "create table t (id int64 primary key, name text not null); " \
          "insert into t values (1, 'ann'), (2, 'bob'); " \
          "select name from t where id = 2;"
    output = shell_output("#{bin}/terndb -c \"#{sql}\"")
    assert_match "CREATE TABLE", output
    assert_match "INSERT 0 2", output
    assert_match(/^ bob$/, output)
    assert_match "(1 row)", output
  end
end
