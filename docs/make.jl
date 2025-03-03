
push!(LOAD_PATH,"../src/")

using Documenter, MarkdownMetadata

makedocs(
    modules = [MarkdownMetadata],
    format = Documenter.HTML(),
    sitename = "MarkdownMetadata.jl",
    pages = [
        "Home" => "index.md",
        "API Reference" => [
            "Overview" => "api/overview.md",
            "Metadata Classes" => "api/classes.md",
            "Metadata Functions" => "api/functions.md"
        ]
    ],
)

deploydocs(;
    repo="https://github.com/TheAhmir/MarkdownMetadata.jl.git",
    branch="gh-pages",
    devbranch="main",
    push_preview=true,
    forcepush=true,
)
