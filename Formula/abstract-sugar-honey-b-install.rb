require File.join(File.dirname(__FILE__), 'abstract-sugar-install')

class AbstractSugarHoneyBInstall < AbstractSugarInstall

  def caveats
    return super <<
    <<-EOS.undent

    Please note that this is a #{Tty.em}#{Tty.red}SugarCRM INTERNAL#{Tty.reset} honey-b build. Please cease and desist using this formula if your contract with SugarCRM does not legally entitle you to have access to this build.

    Also note that this build is a moving target that frequently gets updated. Hence the lack of a checksum on the archive. If you want to reinstall the latest build from honey-b, please fetch the latest archive, uninstall and reinstall like so:

   		#{Tty.white}brew uninstall #{ARGV[0]}
       	brew fetch --force #{ARGV[0]}
       	brew install #{ARGV.join(' ')}#{Tty.reset}

    EOS
  end
end