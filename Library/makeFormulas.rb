
class MakeFormulas
  FLAVS = {	'od' => ['Ult', 'Ent', 'Corp', 'Pro'],
  			'os' => ['Ult', 'Ent', 'Corp', 'Pro', 'CE']
  			}
  REQS = {	'od' => 'abstract-sugar-od-only-install',
  			'os' => 'abstract-sugar-install'
  			}
  BASE = {	'od' => 'AbstractSugarOdOnlyInstall',
  			'os' => 'AbstractSugarInstall'
  			}
  NAME = {	'Ult' => 'Ultimate',
  			'Ent' => 'Enterprise',
  			'Corp' => 'Corporate',
  			'Pro' => 'Professional',
  			'CE' => 'Community_Edition'
  			}
  SEQNR = {	'Ult' => '01',
  			'Ent' => '02',
  			'Corp' => '03',
  			'Pro' => '04',
  			'CE' => '05'
  			}

  def generateScript(type, flav, version, sha1 = nil)
  	baseFile = REQS[type]
  	baseClass = BASE[type]
  	className = 'Sgr' + version.gsub(/\./, '') + flav.downcase
  	fileName = className.downcase + (type=='od' ? '_od' : '') + '.rb'
  	className += 'Od' if type == 'od'
  	major = version.gsub(/(\d+.\d+).*/, '\1') # Match complete number but only keep 2 first numbers (not just digits) of version
  	sha1 = "sha1 '#{sha1}'" unless sha1.nil?

    fileContent = 
 <<-EOS
require File.join(File.dirname(__FILE__), '#{baseFile}')

class #{className} < #{baseClass}
  homepage 'http://support.sugarcrm.com/02_Documentation/01_Sugar_Editions/#{SEQNR[flav]}_Sugar_#{NAME[flav]}/Sugar_#{NAME[flav]}_#{major}/Sugar_#{NAME[flav]}_Release_Notes_#{version}'
  url 'http://honey-b/release_archive/#{flav.downcase}/Sugar#{flav}-#{version}.zip'
  #{sha1}
end
EOS

	File.open(fileName, 'w') { |file| file.write(fileContent) }
	return fileName
  end

  def makeScript(type, flav, version)
  	puts '========================================================='
  	puts "Generating script for #{type}, #{flav}, #{version}"
  	fileName = generateScript(type, flav, version)

  	puts "Fetching archive for #{fileName} ..."
  	command = "brew fetch steegi/sugar/#{fileName.gsub(/\.rb/,'')}"
  	sha1 = `#{command}`[/SHA1:\s*(\w+)/, 1]
  	
  	if $?.success?
	  puts "Updating script with SHA1: #{sha1}"
	  generateScript(type, flav, version, sha1)
	else
	  puts "WARNING! An error occured executing: \"#{command}\""
	  puts $?
	end
  end

  def makeScripts(type, version)
  	FLAVS[type].each { |flav| makeScript(type, flav, version) }
  end

end

type = ARGV[0] ? ARGV[0].downcase : ''
version = ARGV[1]

unless ARGV.count == 2 && ['od', 'os'].include?(type)
	puts "Usage: #{__FILE__} [os | od] <version>"
	puts "Where version of the format M.m.d"
	puts "M, m and d are single or double digits and represent Major, minor and dot release indicator"
else
	MakeFormulas.new.makeScripts(type, version)
end


