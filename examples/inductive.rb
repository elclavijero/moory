require 'moory'

balanced_parens_config = {
  basis: 'basis',
  specs: {
    'basis' => {
      initial: 'ε',
      rules: """
        ε : ( / parenthetical / defer : δ
      """,
    },
    'parenthetical' => {
      initial: 'ε',
      rules: """
        ε : ( / parenthetical / defer  : δ
        ε : ) // reconvene : ω
        δ : ) // reconvene : ω
      """
    }
  }
}

logistic = Moory::Logistic::Controller.new(balanced_parens_config)

"(()".each_char do |c|
  logistic.issue(c)
end

pp logistic.done?
