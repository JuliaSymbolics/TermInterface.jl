using Documenter
using TermInterface

const TERMINTERFACE_PATH = dirname(pathof(TermInterface))


makedocs(
    modules=[TermInterface],
    sitename="TermInterface.jl",
    pages=[
        "index.md"
        # "api.md"
    ],
    checkdocs=:all,
)

deploydocs(repo="github.com/JuliaSymbolics/TermInterface.jl.git")
