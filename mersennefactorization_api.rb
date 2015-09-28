#!/usr/bin/env ruby

require 'openssl'

class MersenneFactorization
  def initialize n=nil
    @N = n.to_i
  end

  def file_input file
    raise "File does not exits" if !File.exist? "#{file}"
    rsa = OpenSSL::PKey::RSA.new File.read "#{file}"
    @N = rsa.params["n"].to_i
  end

  def exploit
    raise "No factorization target found" if @N.nil?
    return expcore
  end

private
  def expcore
  #two mersenne prime product
    mers = mersenne_file.drop_while {|i| i>@N}
    mers.each do |p|
      mers.each do |q|
        break if p*q > @N
        if p*q == @N
          p, q = q, p if q > p
          return p, q
        end
      end
    end
    return nil
  end

  def mersenne_file
    mers = []
    File.open("./mersenne_primes").each do |line|
      mers << 2 ** line.match(/\d+\s+(\d+)/)[1].to_i - 1
    end
    return mers
  end
end

#testing
#n = 658416274830184544125027519921443515789888264156074733099244040126213682497714032798116399288176502462829255784525977722903018714434309698108208388664768262754316426220651576623731617882923164117579624827261244506084274371250277849351631679441171018418018498039996472549893150577189302871520311715179730714312181456245097848491669795997289830612988058523968384808822828370900198489249243399165125219244753790779764466236965135793576516193213175061401667388622228362042717054014679032953441034021506856017081062617572351195418505899388715709795992029559042119783423597324707100694064675909238717573058764118893225111602703838080618565401139902143069901117174204252871948846864436771808616432457102844534843857198735242005309073939051433790946726672234643259349535186268571629077937597838801337973092285608744209951533199868228040004432132597073390363357892379997655878857696334892216345070227646749851381208554044940444182864026513709449823489593439017366358869648168238735087593808344484365136284219725233811605331815007424582890821887260682886632543613109252862114326372077785369292570900594814481097443781269562647303671428895764224084402259605109600363098950091998891375812839523613295667253813978434879172781217285652895469194181218343078754501694746598738215243769747956572555989594598180639098344891175879455994652382137038240166358066403475457
#ff = MersenneFactorization.new n
#p ff.exploit

#ff = MersenneFactorization.new
#ff.file_input "./test/test.pub"
#p ff.exploit