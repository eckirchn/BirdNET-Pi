# this should only contain functions and assignments, ie source install.sh should not have side effects.

get_tf_whl () {
  # Runtime only, not the BirdNET model. birdnet-team does not publish these
  # Pi wheels. They are PINTO0309 TensorFlow Lite builds, hosted as
  # Nachtzuster/BirdNET-Pi release v0.1 (the 2.11.0 wheel is taken from
  # PINTO0309/TensorflowLite-bin; the 2.17.1 wheels were built from those
  # instructions). The identification weights stay in model/.
  BASE_URL=https://github.com/Nachtzuster/BirdNET-Pi/releases/download/v0.1/

  ARCH=$(uname -m)
  PY_VERSION=$(python3 -c "import sys; print(f'{sys.version_info[0]}{sys.version_info[1]}')")
  case "${ARCH}-${PY_VERSION}" in
    aarch64-39)
      WHL=tflite_runtime-2.11.0-cp39-none-linux_aarch64.whl
      ;;
    aarch64-311)
      WHL=tflite_runtime-2.17.1-cp311-cp311-linux_aarch64.whl
      ;;
    aarch64-312)
      WHL=tflite_runtime-2.17.1-cp312-cp312-linux_aarch64.whl
      ;;
    aarch64-313)
      WHL=tflite_runtime-2.17.1-cp313-cp313-linux_aarch64.whl
      ;;
    x86_64-39)
      WHL=tflite_runtime-2.11.0-cp39-cp39-linux_x86_64.whl
      ;;
    x86_64-311)
      WHL=tflite_runtime-2.17.1-cp311-cp311-linux_x86_64.whl
      ;;
    x86_64-312)
      WHL=tflite_runtime-2.17.1-cp312-cp312-linux_x86_64.whl
      ;;
    x86_64-313)
      WHL=tflite_runtime-2.17.1-cp313-cp313-linux_x86_64.whl
      ;;
    *)
      echo "No tflite version found for ${ARCH}-${PY_VERSION}"
      WHL=''
      ;;
  esac
  if [ -n "$WHL" ]; then
    {
      curl -L -o $HOME/BirdNET-Pi/$WHL $BASE_URL$WHL
      sed "s/tensorflow.*/$WHL/" $HOME/BirdNET-Pi/requirements.txt > requirements_custom.txt
    }
  fi
}
