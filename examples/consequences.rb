require 'moory'

pipcv_config = {
  basis: 'basis',
  specs: {
    'basis' => {
      rules: """
      ^ : constant : $

      ^ : variable : $

      ^ : prefix / open          / defer : Δ

      ^ : (      / parenthetical / defer : Δ

      $ : infix  / open          / defer : Δ
      
      Δ : term : $
      """,
    },
    'open' => {
      rules: """
      ^ : constant / term          / reconvene : $

      ^ : variable / term          / reconvene : $

      ^ : prefix   / open          / defer : Δ

      ^ : (        / parenthetical / defer : Δ

      $ : infix    / open          / defer : Δ
      
      Δ : term     / term          / reconvene : $
      """,
    },
    'parenthetical' => {
      rules: """
      ^ : constant : C

      ^ : variable : C

      ^ : prefix / open          / defer : Δ

      ^ : (      / parenthetical / defer : Δ

      ^ : )      / void          / reconvene : $

      C : infix  / open          / defer : Δ

      C : )      / term          / reconvene : $
      
      Δ : term : C
      """
    }
  }
}

logistic = Moory::Logistic::Controller.new(pipcv_config)

pp logistic.issue('(')
pp logistic.issue('(')
pp logistic.issue('prefix')
pp logistic.issue('constant')
pp logistic.issue('infix')
pp logistic.issue('prefix')
pp logistic.issue('(')
pp logistic.issue('variable')
pp logistic.issue('infix')
pp logistic.issue('prefix')
pp logistic.issue('(')
pp logistic.issue('variable')
pp logistic.issue(')')
pp logistic.issue(')')
pp logistic.issue(')')
pp logistic.issue(')')
pp logistic.issue('infix')
pp logistic.issue('variable')
