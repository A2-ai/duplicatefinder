local seen_identifiers = {}
local identifier_counts = {}
local seen_labels = {}
local label_counts = {}

function Pandoc(doc)
    for _, block in ipairs(doc.blocks) do
        local anchor = block.identifier
        if anchor then
            if seen_identifiers[anchor] then
                identifier_counts[anchor] = (identifier_counts[anchor] or 1) + 1
                quarto.log.error("Duplicate anchor identifier found: " .. anchor .. " (" .. identifier_counts[anchor] .. " times)")
            else
                seen_identifiers[anchor] = true
            end
        end
        
        if block.t == 'RawBlock' and block.format == 'latex' then
            local label = block.text:match("\\label%{([^}]+)%}")
            if label then
                if seen_labels[label] then
                    label_counts[label] = (label_counts[label] or 1) + 1
                    quarto.log.error("Duplicate LaTeX label found: " .. label .. " (" .. label_counts[label] .. " times)")
                else
                    seen_labels[label] = true
                end
            end
        end
    end

    return doc
end

return {
    {Pandoc = Pandoc}
}



