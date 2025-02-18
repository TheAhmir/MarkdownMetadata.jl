
push!(LOAD_PATH,"../src/")

using Documenter, MarkdownMetadata

makedocs(
    modules = [MarkdownMetadata],
    format = Documenter.HTML(),
    sitename = "MarkdownMetadata Documentation",
    pages = [
        "Home" => "index.md",
        "API Reference" => [
            "Overview" => "api/overview.md",
            "Metadata Classes" => "api/classes.md",
            "Metadata Functions" => "api/functions.md"
        ]
    ],
    remotes = nothing
)
