{
  description = "My thesis";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system: 
      with import nixpkgs { system = system; };
      let pygmentize = python312Packages.pygments;
    in rec {
        packages = rec {

	  thesis = 
	    stdenv.mkDerivation rec {
              name = "thesis";

              system = system;

              nativeBuildInputs = [
	        pygmentize
		texliveFull
              ];

              src = self;

	      buildPhase = ''
	        make all
	      '';

              installPhase = ''
		  mkdir -p $out
		  cp thesis.pdf $out/thesis.pdf
	      '';

              out = [ "out" ];
            };

	    default = thesis;

        };

        devShells = rec {
          default =  
            mkShell {
              name = "devshell";

              packages = [
	        pygmentize
		texliveFull
              ];
            };

        };
      }
    );
}
