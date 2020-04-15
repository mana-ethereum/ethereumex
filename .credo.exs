%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "src/", "web/", "apps/"],
        excluded: []
      },
      checks: [
        {Credo.Check.Readability.ParenthesesOnZeroArityDefs, [parens: true]},
        {Credo.Check.Refactor.LongQuoteBlocks, false},
        {Credo.Check.Readability.StrictModuleLayout, []}
      ]
    }
  ]
}
