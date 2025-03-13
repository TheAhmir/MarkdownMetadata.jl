module Parser

using TOML, YAML

export read_docs, extract_metadata

# md, yaml, toml, json, tex
accepted_docs = ["md", "yaml", "toml", "json", "tex"]

function read_docs(path::String)
    return [x for x in readdir(path) if split(x, '.')[end] in accepted_docs]
end

function extract_metadata(format::Symbol, path::String)
    extract_metadata(Val(format), path)
end

function extract_metadata(::Val{:markdown}, path::String)
    content = read(path, String)

    if occursin("---", content)
        parts = split(content, "---", limit=3)
        if occursin("=", parts[2])
            metadata = try
                TOML.parse(parts[2])
            catch
                Dict()
            end
        else
            metadata = try
                YAML.load(parts[2])
            catch
                Dict()
            end
        end
        return metadata, strip(parts[3])
    end
    return Dict(), content
            
end


# # Extract frontmatter metadata from markdown
# function extract_metadata(md_path)
#     content = read(md_path, String)
#     if occursin("---", content)
#         parts = split(content, "---", limit=3)
#         metadata = try
#             TOML.parse(parts[2])  # Extract frontmatter as TOML
#         catch
#             Dict()
#         end
#         return metadata, strip(parts[3])  # Return metadata and post content
#     end
#     return Dict(), content
# end
end
