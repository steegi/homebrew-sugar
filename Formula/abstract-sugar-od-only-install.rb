require File.join(File.dirname(__FILE__), 'abstract-sugar-install')

class AbstractSugarOdOnlyInstall < AbstractSugarInstall

  def caveats
    return super << 'Please note that this is an "On-Demand Only" release with special restriction as per your agreement with SugarCRM.'
  end
end