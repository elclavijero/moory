require 'moory'

prefix_infix_constant_config = {
  basis: 'basis',
  specs: {
    'basis' => {
      rules: """
      ^ : constant : $

      ^ : prefix / open / defer : Δ

      $ : infix  / open / defer : Δ
      
      Δ : term : $
      """,
    },
    'open' => {
      rules: """
      ^ : constant / term / reconvene : $

      ^ : prefix / open / defer : Δ

      $ : infix  / open / defer : Δ
      
      Δ : term / term / reconvene : $
      """,
    }
  }
}

logistic = Moory::Logistic::Controller.new(prefix_infix_constant_config)

%w{
  constant
  infix
  prefix
  constant
  infix
  constant
  infix
  prefix
}.each do |w|
  logistic.issue(w)
end

pp logistic.done?
