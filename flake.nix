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
	  tex = (texlive.combine {
	    inherit (texlive) 
	      scheme-minimal
	      amsfonts
	      amsmath
	      amscls
	      amstex
	      bussproofs
	      cancel
	      caption
	      embedall
	      epstopdf
	      epstopdf-pkg
	      float
	      geometry
	      grfext
	      hyperref
	      infwarerr
	      latexmk
	      latex-bin
	      listings
	      minted
	      ninecolors
	      setspace
	      siunitx
	      tabularray
	      todonotes
	      url
	      xcolor;
	  });
    in rec {
        packages = 
	  let makeThesis = flags:
	    stdenvNoCC.mkDerivation rec {
              name = "thesis";

              system = system;

              buildInputs = [
	        coreutils
		gnumake
	        pygmentize
		tex
		which
              ];

              src = self;

              phases = ["unpackPhase" "buildPhase" "installPhase"];

	      buildPhase = ''
	        appendToVar PATH ${toString buildInputs}
                mkdir -p .cache/texmf-var
                env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var    \
                  SOURCE_DATE_EPOCH=${toString self.lastModified} \
		  make OPTIONS='[${toString flags}]' all
	      '';

              installPhase = ''
		  mkdir -p $out
		  cp thesis.pdf $out/thesis.pdf
	      '';
            };
	in rec {
	  thesis = makeThesis [];
	  debug = makeThesis ["dbg"];
	  default = thesis;
        };

        devShells = rec {
          default =  
            mkShell {
              name = "devshell";

              packages = [
	        pygmentize
		tex
		gnumake
		gnused
              ];
            };

        };
      }
    );
}
