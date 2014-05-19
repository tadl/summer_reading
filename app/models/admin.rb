class Admin < ActiveRecord::Base
  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |admin|
      if auth.extra.raw_info['hd'] == 'tadl.org' 
        admin.provider = auth.provider
        admin.uid = auth.uid
        admin.name = auth.info.name
        admin.email = auth.info.email
        admin.avatar = auth.info.image
        admin.oauth_token = auth.credentials.token
        admin.oauth_expires_at = Time.at(auth.credentials.expires_at)
        admin.save!
      end
    end
  end
end
