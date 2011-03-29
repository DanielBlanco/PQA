namespace :pqa do

  desc "Add some initial configuration"
  task :init_config => :environment do
    if Configuration.find(:first).nil?
      Configuration.create(:name => 'File Types', :config_values => 'Java,JSP,Velocity,Image,Stylesheet,Javascript,Configuration,Mainframe Packet,Batch')
      Configuration.create(:name => 'Action', :config_values => 'Add,Update,Delete')
      Configuration.create(:name => 'Ticket Types', :config_values => 'Enhacement,Application Defect,Database,Technical Service,Batch')
      Configuration.create(:name => 'Environments', :config_values => 'DEV,QA,STAGE,PRE-PROD,PROD')
      Configuration.create(:name => 'Modules', :config_values => 'Electronic Statements,QuickRemit,Account Maintanance,BounceBack Manager')
	  Configuration.create(:name => 'Business Mashups', :config_values => 'http://10.32.14.13/tmtrack/tmtrack.dll?')
	  Configuration.create(:name => 'Pagination Number', :config_values => '15')
    end
  end

  desc "Add TSYS environment specific files"
  task :esf_config => :environment do
    if Envspecific.find(:first).nil?
      Envspecific.create(:file => '$/ngus/*/account_pay_config.xml')
	  Envspecific.create(:file => '$/ngus/*/accountpay_batch_startup.sh')
	  Envspecific.create(:file => '$/ngus/*/accountpay_conversion_batch_startup.sh')
	  Envspecific.create(:file => '$/ngus/*/application.xml')
	  Envspecific.create(:file => '$/ngus/*/batch_failure.properties')
	  Envspecific.create(:file => '$/ngus/*/campaign_tracker_batch.sh')
	  Envspecific.create(:file => '$/ngus/*/campaign_tracker_service_config.xml')
	  Envspecific.create(:file => '$/ngus/*/content_manager.xml')
	  Envspecific.create(:file => '$/ngus/*/correspondence_promotion_batch.sh')
	  Envspecific.create(:file => '$/ngus/*/credit_limit_batch.sh')
	  Envspecific.create(:file => '$/ngus/*/CCardTsys.cer')
	  Envspecific.create(:file => '$/ngus/*/database_config.xml')
	  Envspecific.create(:file => '$/ngus/*/databasereporting')
	  Envspecific.create(:file => '$/ngus/*/DBExclude')
	  Envspecific.create(:file => '$/ngus/*/dcsi_config.xml')
	  Envspecific.create(:file => '$/ngus/*/eidverifier_service_config.xml')
	  Envspecific.create(:file => '$/ngus/*/email_bouncebacks_batch.sh')
	  Envspecific.create(:file => '$/ngus/*/email_bouncebacks_batch_log_config.xml')
	  Envspecific.create(:file => '$/ngus/*/estatement_batch.sh')
	  Envspecific.create(:file => '$/ngus/*/estatement_service_config.xml')
	  Envspecific.create(:file => '$/ngus/*/estatements_config.xml')
	  Envspecific.create(:file => '$/ngus/*/estmt_notif_batch_config.xml')
	  Envspecific.create(:file => '$/ngus/*/estmt_notification_batch_log_config.xml')
	  Envspecific.create(:file => '$/ngus/*/files.xml')
	  Envspecific.create(:file => '$/ngus/*/hbxClientInfo.js')
	  Envspecific.create(:file => '$/ngus/*/logconfig.xml')
	  Envspecific.create(:file => '$/ngus/*/monitoring_console.properties')
	  Envspecific.create(:file => '$/ngus/*/NewHandlerLayer-ejb-jar.xml')
	  Envspecific.create(:file => '$/ngus/*/NewHandlerLayer-weblogic-ejb-jar.xml')
	  Envspecific.create(:file => '$/ngus/*/NewMessagingLayer-ejb-jar.xml')
	  Envspecific.create(:file => '$/ngus/*/NewMessagingLayer-weblogic-ejb-jar.xml')
	  Envspecific.create(:file => '$/ngus/*/NewMQParams.xml')
	  Envspecific.create(:file => '$/ngus/*/notification_batch_startup.sh')
	  Envspecific.create(:file => '$/ngus/*/packets.xml')
	  Envspecific.create(:file => '$/ngus/*/payment_service_config.xml')
	  Envspecific.create(:file => '$/ngus/*/riskanalysis_service_config.xml')
	  Envspecific.create(:file => '$/ngus/*/site_config.xml')
	  Envspecific.create(:file => '$/ngus/*/sms_service_config.xml')
	  Envspecific.create(:file => '$/ngus/*/SRtest1.cer')
	  Envspecific.create(:file => '$/ngus/*/SRtest1.pkcs8')
	  Envspecific.create(:file => '$/ngus/*/SRtest2.cer')
	  Envspecific.create(:file => '$/ngus/*/SRtest2.pkcs8')
	  Envspecific.create(:file => '$/ngus/*/treecache.xml')
	  Envspecific.create(:file => '$/ngus/*/TT_*.txt')
	  Envspecific.create(:file => '$/ngus/*/TSYS01keystore.jks')
	  Envspecific.create(:file => '$/ngus/*/TSYS.cer')
	  Envspecific.create(:file => '$/ngus/*/tsysyesbtrsa.cert')
	  Envspecific.create(:file => '$/ngus/*/tsysyesbtkeystore.jks')
	  Envspecific.create(:file => '$/ngus/*/tsys_system.properties')
	  Envspecific.create(:file => '$/ngus/*/TSYS-priv.pkcs8')
	  Envspecific.create(:file => '$/ngus/*/usclientconfig.xml')
	  Envspecific.create(:file => '$/ngus/*/uk_notification_batch_startup.sh')
	  Envspecific.create(:file => '$/ngus/*/wachovia.cer')
	  Envspecific.create(:file => '$/ngus/*/wcl_decryption.properties')
	  Envspecific.create(:file => '$/ngus/*/wcl_encryption.properties')
	  Envspecific.create(:file => '$/ngus/*/web.xml')
	  Envspecific.create(:file => '$/ngus/*/weblogic.xml')
    end
  end


  desc "Run all init_config tasks"
  task :all => [:init_config, :esf_config]
end
