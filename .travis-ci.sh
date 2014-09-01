# Install OCaml and OPAM PPAs
case "$OCAML_VERSION" in
  4.01.0) ppa=avsm/ocaml41+opam11 ;;
  4.02.0) ppa=avsm/ocaml41+opam11 ;;
  *) echo Unknown $OCAML_VERSION; exit 1 ;;
esac

echo "yes" | sudo add-apt-repository ppa:$ppa
sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam time

echo OCaml version
ocaml -version

export OPAMYES=1

opam init git://github.com/ocaml/opam-repository >/dev/null 2>&1
opam repo add mirage-dev .

TARGETS="mirage-http mirage"

case "$OCAML_VERSION" in
  4.01.0)
    opam install ${TARGETS}
  ;;
  4.02.0)
    opam switch 4.02.0
    opam install ${TARGETS}
  ;;
  *)
    echo "Nothing to do";
    exit 1 ;;
esac

eval `opam config env`
git clone -b mirage2 git://github.com/avsm/mirage-skeleton
cd mirage-skeleton
make configure
make depend
make build
