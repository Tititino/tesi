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
	  texliveEnv = 
	    texliveSmall.withPackages (p: with p; [
	      amsfonts
	      # amssymb
	      amsmath
	      amstex
	      # amsthm
	      babel
	      bibtex
	      bussproofs
	      caption
	      # subcaption
	      embedall
	      float
	      geometry
	      hyperref
	      # graphicx
	      listings
	      minted
	      ninecolors
	      # epsfig
	      setspace
	      siunitx
	      tabularray
	      todonotes
	      url
	      xcolor
	    ]);
    in rec {
        # packages = rec {
	#   thesis = 
	#     stdenv.mkDerivation rec {
        #       name = "thesis";

        #       system = system;

        #       nativeBuildInputs = [
	#         pygmentize
	# 	texliveEnv
	# 	which
        #       ];

        #       src = self;

	#       buildPhase = ''
	#         export PATH=${which}/bin/which:${pygmentize}/bin/pygmentize:$PATH
	#         make LCC=${texliveEnv}/bin/lualatex BTX=${texliveEnv}/bin/bibtex all
	#       '';

        #       installPhase = ''
	# 	  mkdir -p $out
	# 	  cp thesis.pdf $out/thesis.pdf
	#       '';

        #       out = [ "out" ];
        #     };

	#     default = thesis;

        # };

        devShells = rec {
          default =  
            mkShell {
              name = "devshell";

              packages = [
	        pygmentize
		texliveEnv
		gnumake
              ];
            };

        };
      }
    );
}
