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

%w{
  (
    (
      prefix
      constant
      infix
      prefix
      (
        variable
        infix
        prefix
        (
          variable
        )
      )
    )
  )
  infix
}.each do |w|
  logistic.issue(w)
end

pp logistic.deferrals

pp logistic.done?

