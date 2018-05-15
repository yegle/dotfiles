with import <nixpkgs> {};

let
  spark_no_mesos = spark.override { mesosSupport = false; };
  vim_with_python3 = vim_configurable.override { python = python3; };
  aspell_with_dict = aspellWithDicts(ps: [ps.en]);
  weechat_with_aspell = weechat.override { aspell = aspell_with_dict; };
in
stdenv.mkDerivation rec {
  name = "shell";
  env = buildEnv {
    name = name;
    paths = buildInputs;
  };
  buildInputs = [
    aspell_with_dict
    bash
    cmake
    go
    palemoon
    tzdata
    vim_with_python3
    weechat_with_aspell
    zsh

    (python.buildEnv.override {
        ignoreCollisions = true;
        extraLibs = with pythonPackages; [
            altair
            ipython
            matplotlib
            notebook
            pandas
        ];
    })
    (python3.buildEnv.override {
        ignoreCollisions = true;
        extraLibs = with python3Packages; [
            altair
            ipython
            matplotlib
            notebook
            pandas
            virtualenv
        ];
    })
  ];
  shellHook = ''
    export PYSPARK_DRIVER_PYTHON=$(which jupyter-notebook)
    exec env -u TMP -u TEMP -u TEMPDIR -u XDG_RUNTIME_DIR -u TMPDIR zsh
  '';
}
