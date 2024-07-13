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
	      babel-italian
	      beamer
	      bussproofs
	      caladea
	      cancel
	      carlito
	      caption
	      embedall
	      epstopdf
	      epstopdf-pkg
	      float
	      fontaxes
	      geometry
	      grfext
	      hyperref
	      infwarerr
	      latexmk
	      latex-bin
	      minted
	      multirow
	      ninecolors
	      pdfx
	      setspace
	      siunitx
	      stmaryrd
	      tabularray
	      todonotes
	      url
	      xcolor
	      xmpincl;
	  });
    in rec {
        packages = 
	  let makePdf = fname: flags:
	    stdenvNoCC.mkDerivation rec {
              name = fname;

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
		  make OPTIONS='[${toString flags}]' LCC=pdflatex ${fname}.pdf
	      '';

              installPhase = ''
		  mkdir -p $out
		  cp ${fname}.pdf $out/${fname}.pdf
	      '';
            };
	in rec {
	  thesis = makePdf "thesis" [];
	  debug = makePdf "thesis" ["dbg"];
	  riassunto = makePdf "riassunto" [];
	  presentazione = makePdf "presentazione" [];
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
		(aspellWithDicts (p: [p.en p.en-computers p.en-science p.it]))
              ];

	      shellHook = ''
	        alias spellcheck="aspell --mode=tex -c"
	      '';
            };

        };
      }
    );
}
