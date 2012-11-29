require 'formula'

class AbstractSugarInstall < Formula
  homepage 'http://www.sugarcrm.com'

  depends_on 'curl' if !(build.include?('without-config_si') || build.include?('without-sugar-install'))

  def instance_name;  self.class.name.downcase          end
  def install_path;   share + instance_name             end
  def config_si;      "#{install_path}/config_si.php"   end
  def app_url;        "http://localhost:8888/share/#{instance_name}" end
  def install_url;    "#{app_url}/install.php?goto=SilentInstall&cli=true"   end



  option 'without-config_si', "Only extracts the files (implies --without-sugar-install)"
  option 'without-sugar-install', "Installs the files and creates the config_si but does not run the Sugar installer (implies --without-config_si is not specified)"
  option 'with-demo-data', 'Creates demo data in the database (config_si setting)'

  def install

    ohai "Moving extracted files to: #{install_path}"
    (install_path).install Dir['*']
    puts 'Move completed'

    if build.include?('without-config_si') then return end

    ohai "Creating silent installer file: #{config_si}"
    File.open(config_si, 'w') { |file| file.write(config_si_content) }
    puts 'Silent installer file ready'
    
    if build.include?('without-sugar-install') then return end

    ohai "Calling SugarCRM installer: #{config_si}"

    # We need to link the keg to be able to run the Sugar installer
    keg = Keg.new(prefix)
    keg.link

    curlcall = "curl -s -m 300 #{install_url}"
    #puts curlcall
    output = `#{curlcall}`

    # Unlinking the keg to not conflict with the rest of the installer
    keg.unlink

    unless output.include? "<bottle>Success!</bottle>"
       raise "SugarCRM installation failed!"
    end  
    
  end

  def caveats
    if build.include?('without-config_si') then return <<-EOS.undent
    Only the SugarCRM #{version} files where installed in #{share}.
    You will be redirected to the installer the first time you access the application.
    EOS
    end

    if build.include?('without-sugar-install') then return <<-EOS.undent
    The SugarCRM #{version} files where installed and a config_si.php was created in #{share}.
    The first time you access the application it will run the silent installer based on the config_si.php.
    EOS
    end

    return <<-EOS.undent
    Sugar installation completed successfully!
    You can access it by pointing your browser to: #{app_url}
    EOS
  end

  def demo_data
    (build.include?('with-demo-data')) ? 'yes' : 'no'
  end

  def config_si_content

    if (ENV['SGRBREW_CONFIG_SI_TEMPLATE'] && File.exist?(ENV['SGRBREW_CONFIG_SI_TEMPLATE']))
      puts 'Reading config_si template from file ' << ENV['SGRBREW_CONFIG_SI_TEMPLATE']
      config = eval '"' + File.read(ENV['SGRBREW_CONFIG_SI_TEMPLATE']) + '"'
    else
      config = <<-EOS
      <?php
        $sugar_config_si = array (
          'setup_db_host_name' => 'localhost',
          'setup_db_database_name' => '#{instance_name}',
          'setup_db_drop_tables' => true,
          'setup_db_create_database' => true,
          'setup_site_admin_user_name' => 'admin',
          'setup_site_admin_password' => 'asdf',
          'setup_db_create_sugarsales_user' => false,
          'setup_db_admin_user_name' => 'root',
          'setup_db_admin_password' => 'root',
          'setup_site_url' => '#{app_url}',
          'dbUSRData' => 'provide',
          'setup_db_type' => 'mysql',
          'setup_system_name' => 'SugarCRM',
          'default_currency_iso4217' => 'USD',
          'default_currency_name' => 'US Dollars',
          'default_currency_significant_digits' => '2',
          'default_date_format' => 'm/d/Y',
          'default_time_format' => 'h:ia',
          'default_decimal_seperator' => '.',
          'default_export_charset' => 'UTF-8',
          'default_language' => 'en_us',
          'default_locale_name_format' => 's f l',
          'default_number_grouping_seperator' => ',',
          'export_delimiter' => ',',
          'demoData' => '#{demo_data}',
          'setup_site_sugarbeet_anonymous_stats' => '1',
          'setup_site_sugarbeet_automatic_checks' => '1',
          'setup_site_specify_guid' => '0',
          'setup_site_guid' => 'auto',
          );
    EOS
    end

    config
  end

end