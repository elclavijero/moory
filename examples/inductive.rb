require 'moory'

nested_terms_config = {
  basis: 'basis',
  specs: {
    'basis' => {
      initial: '^',
      rules: """
      ^ : constant : $

      ^ : prefix / prefixed / defer : Δ

      Δ : term : $
      """,
    },
    'prefixed' => {
      initial: '^',
      rules: """
      ^ : constant / term / reconvene : $

      ^ : prefix / prefixed / defer   : Δ

      Δ : term / term / reconvene : $
      """
    }
  }
}

logistic = Moory::Logistic::Controller.new(nested_terms_config)

%w{
  prefix
  prefix
  prefix
  constant
}.each do |w|
  logistic.issue(w)
end

pp logistic.done?
