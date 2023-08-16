local seen_identifiers = {}
local identifier_counts = {}
local seen_labels = {}
local label_counts = {}
local reported_duplicates = {} -- Keep track of reported duplicates

function Pandoc(doc)
    for _, block in ipairs(doc.blocks) do
        local anchor = block.identifier
        if anchor and anchor ~= "" then
            if seen_identifiers[anchor] then
                identifier_counts[anchor] = (identifier_counts[anchor] or 1) + 1
            else
                seen_identifiers[anchor] = true
            end
        end
        
        if block.t == 'RawBlock' and block.format == 'latex' then
            local label = block.text:match("\\label%{([^}]+)%}")
            if label then
                if seen_labels[label] then
                    label_counts[label] = (label_counts[label] or 1) + 1
                else
                    seen_labels[label] = true
                end
            end
        end
    end

    for anchor, count in pairs(identifier_counts) do
        if count > 1 and not reported_duplicates[anchor] then
            quarto.log.error("Duplicate anchor identifier found: " .. anchor .. " (" .. count .. " times)")
            reported_duplicates[anchor] = true
        end
    end

    for label, count in pairs(label_counts) do
        if count > 1 and not reported_duplicates[label] then
            quarto.log.error("Duplicate LaTeX label found: " .. label .. " (" .. count .. " times)")
            reported_duplicates[label] = true
        end
    end

    return doc
end

return {
    {Pandoc = Pandoc}
}
