# Duplicatefinder Extension For Quarto

This is a Quarto filter that will search through the anchor ids for duplicates. It will then print an error statement in the terminal with the name of the duplicate and how many times the duplicate appears in the Quarto project. 

## Installing

```bash
quarto add A2-ai/duplicatefinder
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

Render the Quarto doc or book as your normally would, if there are any duplicates they will print as an error statement in the R terminal.

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

