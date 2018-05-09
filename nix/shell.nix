with import <nixpkgs> {};

let
  spark_no_mesos = spark.override { mesosSupport = false; };
  vim_with_python3 = vim_configurable.override { python = python3; };
in
stdenv.mkDerivation rec {
  name = "shell";
  env = buildEnv {
    name = name;
    paths = buildInputs;
  };
  buildInputs = [
    vim_with_python3
    go
    cmake

    (python3.buildEnv.override {
        ignoreCollisions = true;
        extraLibs = with python3Packages; [
            ipython
            notebook
            pandas
            matplotlib
            virtualenv
        ];
    })
  ];
  shellHook = ''
    export PYSPARK_DRIVER_PYTHON=$(which jupyter-notebook)
  '';
}
