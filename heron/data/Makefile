
BLD=build/latex
all: run-book run-sed run-latex

init:
	heron -f init

run-book:
	heron -vdft books build

run-sed: run-sed-xml-latex run-sed-greek-latex

run-sed-echo:
	@echo "Running @sed for LaTeX reserve words"

run-sed-xml-latex:
	@sed -i "s/&amp;/&/g" $(BLD)/*.tex

run-sed-greek-latex:
	@sed -i "s/Α/\\\textAlpha/g" $(BLD)/*.tex
	@sed -i "s/α/\\\textalpha /g" $(BLD)/*.tex
	@sed -i "s/Β/\\\textBeta/g" $(BLD)/*.tex
	@sed -i "s/β/\\\textbeta/g" $(BLD)/*.tex
	@sed -i "s/Γ/\\\textGamma/g" $(BLD)/*.tex
	@sed -i "s/γ/\\\textgamma/g" $(BLD)/*.tex
	@sed -i "s/Δ/\\\textDelta/g" $(BLD)/*.tex
	@sed -i "s/δ/\\\textdelta/g" $(BLD)/*.tex
	@sed -i "s/Ε/\\\textEpsilon/g" $(BLD)/*.tex
	@sed -i "s/ε/\\\textepsilon/g" $(BLD)/*.tex
	@sed -i "s/Ζ/\\\textZeta/g" $(BLD)/*.tex
	@sed -i "s/ζ/\\\textzeta/g" $(BLD)/*.tex
	@sed -i "s/Η/\\\textEta/g" $(BLD)/*.tex
	@sed -i "s/η/\\\texteta/g" $(BLD)/*.tex
	@sed -i "s/Θ/\\\textTheta/g" $(BLD)/*.tex
	@sed -i "s/θ/\\\texttheta/g" $(BLD)/*.tex
	@sed -i "s/Ι/\\\textIota/g" $(BLD)/*.tex
	@sed -i "s/ι/\\\textiota/g" $(BLD)/*.tex
	@sed -i "s/Κ/\\\textKappa/g" $(BLD)/*.tex
	@sed -i "s/κ/\\\textkappa/g" $(BLD)/*.tex
	@sed -i "s/Λ/\\\textLambda/g" $(BLD)/*.tex
	@sed -i "s/λ/\\\textlambda/g" $(BLD)/*.tex
	@sed -i "s/Μ/\\\textMu/g" $(BLD)/*.tex
	@sed -i "s/μ/\\\textmu/g" $(BLD)/*.tex
	@sed -i "s/Ν/\\\textNu/g" $(BLD)/*.tex
	@sed -i "s/ν/\\\textnu/g" $(BLD)/*.tex
	@sed -i "s/Ο/\\\textOmikron/g" $(BLD)/*.tex
	@sed -i "s/ο/\\\textomikron/g" $(BLD)/*.tex
	@sed -i "s/Π/\\\textPi/g" $(BLD)/*.tex
	@sed -i "s/π/\\\textpi/g" $(BLD)/*.tex
	@sed -i "s/Ρ/\\\textRho/g" $(BLD)/*.tex
	@sed -i "s/ρ/\\\textrho/g" $(BLD)/*.tex
	@sed -i "s/Σ/\\\textSigma/g" $(BLD)/*.tex
	@sed -i "s/σ/\\\textsigma/g" $(BLD)/*.tex
	@sed -i "s/ς/\\\textvarsigma/g" $(BLD)/*.tex
	@sed -i "s/Τ/\\\textTau/g" $(BLD)/*.tex
	@sed -i "s/τ/\\\texttau/g" $(BLD)/*.tex
	@sed -i "s/Υ/\\\textUpsilon/g" $(BLD)/*.tex
	@sed -i "s/υ/\\\textupsilon/g" $(BLD)/*.tex
	@sed -i "s/Φ/\\\textPhi/g" $(BLD)/*.tex
	@sed -i "s/φ/\\\textphi/g" $(BLD)/*.tex
	@sed -i "s/Χ/\\\textChi/g" $(BLD)/*.tex
	@sed -i "s/χ/\\\textchi/g" $(BLD)/*.tex
	@sed -i "s/Ψ/\\\textPsi/g" $(BLD)/*.tex
	@sed -i "s/ψ/\\\textpsi/g" $(BLD)/*.tex
	@sed -i "s/Ω/\\\textOmega/g" $(BLD)/*.tex
	@sed -i "s/ω/\\\textomega/g" $(BLD)/*.tex
	@sed -i "s/Ξ/\\\textXi/g" $(BLD)/*.tex
	@sed -i "s/ξ/\\\textxi/g" $(BLD)/*.tex

run-latex:
	heron -vd latex
