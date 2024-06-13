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
	      # amsthm
	      babel
	      bibtex
	      bussproofs
	      caption
	      # subcaption
	      embedall
	      epstopdf
	      epstopdf-pkg
	      float
	      geometry
	      grfext
	      hyperref
	      infwarerr
	      # graphicx
	      latexmk
	      latex-bin
	      listings
	      minted
	      ninecolors
	      # epsfig
	      setspace
	      siunitx
	      tabularray
	      todonotes
	      url
	      xcolor;
	  });
    in rec {
        packages = rec {
	  thesis = 
	    stdenvNoCC.mkDerivation rec {
              name = "thesis";

              system = system;

              buildInputs = [
	        coreutils
	        pygmentize
		tex
              ];

              src = self;

              phases = ["unpackPhase" "buildPhase" "installPhase"];

	      buildPhase = ''
                export PATH="${pkgs.lib.makeBinPath buildInputs}";
                mkdir -p .cache/texmf-var
                env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
                  SOURCE_DATE_EPOCH=${toString self.lastModified} \
                  latexmk -interaction=nonstopmode -pdf -lualatex -latexoption="-shell-escape" \
		  -pretex="\pdfvariable suppressoptionalinfo 512\relax" \
		  -usepretex thesis.tex
	      '';

              installPhase = ''
		  mkdir -p $out
		  cp thesis.pdf $out/thesis.pdf
	      '';
            };

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
              ];
            };

        };
      }
    );
}
