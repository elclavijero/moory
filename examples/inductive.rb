require 'moory'

prefix_infix_parenthetical_constant_config = {
  basis: 'basis',
  specs: {
    'basis' => {
      rules: """
      ^ : constant : $

      ^ : prefix / open          / defer : Δ

      ^ : (      / parenthetical / defer : Δ

      $ : infix  / open          / defer : Δ
      
      Δ : term : $
      """,
    },
    'open' => {
      rules: """
      ^ : constant / term          / reconvene : $

      ^ : prefix   / open          / defer : Δ

      ^ : (        / parenthetical / defer : Δ

      $ : infix    / open          / defer : Δ
      
      Δ : term     / term          / reconvene : $
      """,
    },
    'parenthetical' => {
      rules: """
      ^ : constant : C

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

logistic = Moory::Logistic::Controller.new(prefix_infix_parenthetical_constant_config)

%w{
  (
    (
      prefix
      constant
      infix
      prefix
      (
        constant
        infix
        prefix
        (
          constant
        )
      )
    )
  ) 
}.each do |w|
  logistic.issue(w)
end

pp logistic.done?

pp logistic.deferrals
