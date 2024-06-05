using Documenter
using TermInterface

const TERMINTERFACE_PATH = dirname(pathof(Metatheory))


makedocs(
    modules=[TermInterface],
    sitename="TermInterface.jl",
    pages=[
        "index.md"
        "api.md"
        "Tutorials" => tutorials
    ],
)

deploydocs(repo="github.com/JuliaSymbolics/TermInterface.jl.git")
