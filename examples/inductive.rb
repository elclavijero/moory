require 'moory'

nested_terms_config = {
  basis: 'basis',
  specs: {
    'basis' => {
      initial: '^',
      rules: """
      ^ : term : $
      ^ : ( / parenthetical / defer : D

      D : term : $
      """,
    },
    'parenthetical' => {
      initial: '^',
      rules: """
      ^ : ) / void /reconvene       : $
      T : ) / term / reconvene      : $
      
      ^ : term                      : T
      D : term                      : T
      
      ^ : ( / parenthetical / defer : D
      """
    }
  }
}

logistic = Moory::Logistic::Controller.new(nested_terms_config)

%w{
  (
  (
    term
  )
  )
}.each do |w|
  logistic.issue(w)
end

pp logistic.done?
