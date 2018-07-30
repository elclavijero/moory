require 'moory'

class Unit
  include Moory::Efferent

  def initialize(rules:, initial:)
    @initial = initial
    configure(rules)
  end

  def issue(stimulus)
    understand?(stimulus) ?
      super :
      (raise "Unexpected #{stimulus}")
  end

  def prime
    @state = @initial
  end

  private

  def configure(rules)
    Moory::Loader.load(rules:rules, machine:self)
    prime
  end
end

class Logistic
  def initialize(config)
    @config = config
    prepare_units
  end

  def prepare_units
    create_units
    wire_units
    focus_on(@config[:basis])
  end

  def units
    @units ||= {}
  end

  def active_unit
    units[@focus]
  end

  def deferrals
    @deferrals ||= []
  end

  def issue(stimulus)
    active_unit.issue(stimulus)
  end

  def done?
    deferrals.empty?
  end

  private

  def create_units
    @config[:specs].each do |name, spec|
      units.store(name, Unit.new(spec))
    end
  end

  def wire_units
    units.values.each do |v|
      v.repertoire.cram({
        'defer'     => method(:defer),
        'reconvene' => method(:reconvene),
      })
    end
  end

  def focus_on(unit_name)
    @focus = unit_name
  end

  def defer(unit_name)
    deferrals.push(
      {
        name:  @focus.clone,
        state: units[@focus].state.clone
      }
    )
    focus_on(unit_name)
    active_unit.prime
  end

  def reconvene
    raise "Cannot reconvene without prior deferral" if deferrals.empty?

    deferrals.pop.tap do |last_deferral|
      focus_on(last_deferral[:name])
      active_unit.state = last_deferral[:state]
    end
  end
end

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
        ε : ) // reconvene : closed
        δ : ) // reconvene : closed
      """
    }
  }
}

logistic = Logistic.new(balanced_parens_config)

"(()".each_char do |c|
  logistic.issue(c)
end

pp logistic.done?
