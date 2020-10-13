class IntegrationCable < BaseCable
  def login_fail
    stream_json({
      message: 'Sign in failed. Please try again.',
      type: 'LOGIN_FAIL'
    })
  end

  def login_reader_list_fail_name
    stream_json({
      message: 'Two or more names on your Epic account are the same. Please visit the Epic website and give each of your Epic readers a unique name. You can add a middle initial or a number to make names unique.',
      type: 'READER_LIST_FAIL_NAME'
    })
  end

  def login_and_fetch_readers
    return if invalid_login_params?

    stream_json({
        epic_raw_cookie_string: '__cfduid=d2dea7f000000000000000000000000000000000000; expires=Wed, 01-Jul-20 21:52:47 GMT; path=/; domain=.getepic.com; HttpOnly; SameSite=Lax, PHPSESSID=odkb4ls0000000000000000000; path=/; domain=.getepic.com, PHPSESSID=odkb4lsn000000000000000000; expires=Thu, 11-Jun-2020 21:52:48 GMT; Max-Age=864000; path=/; samesite=strict; domain=.getepic.com; secure; HttpOnly, epic_session=8e0c5876-4120-4dbd-b551-3b83cefda5dc%3Ad9800000000000000000000000000000; expires=Wed, 01-Jul-2020 21:52:48 GMT; Max-Age=2592000; path=/; domain=.getepic.com',
        epic_accounts: [
          { account_id: 22_519_080, id: 99_850_362, name: 'Avery' },
          { account_id: 22_519_080, id: 99_898_511, name: 'Bob' },
          { account_id: 22_519_080, id: 99_858_421, name: 'Dave' }
        ],
        beanstack_profiles: [
          { id: 6_290_590, first_name: 'Avery', prefilled_epic_id: 99_850_362, initials: 'AA', image_url: 'https://dowvq86h33m3d.cloudfront.net/profiles/1/image/1/original/B8CFA156-051F-4CEB-98C8-C8D3A9928295.jpg?1598629065' },
          { id: 6_290_589, first_name: 'Dave', prefilled_epic_id: -1, initials: 'DA', image_url: nil },
          { id: 6_290_595, first_name: 'Robert', prefilled_epic_id: 99_898_511, initials: 'RA', image_url: nil }
        ],
        current_beanstack_profile_id: 6_290_590
    })

  end

  def sync_readers
    if ENV['EPIC_INTEGRATION_DEV_MODE'] == 'SYNC_FAIL_LOCKED' # SYNC_FAIL_EPIC_BROKE_API
      stream_json({
        message: "Oh no! Importing is disconnected. We're working on it. Please try again later.",
        type: 'SYNC_FAIL_LOCKED'
      })
      return
    end
#*DTA TODO REDUCE AMOUNT OF DATA RETURNED
    if ENV['EPIC_INTEGRATION_DEV_MODE'] == 'SUCCESS_NO_EARNED_BADGES'
      stream_json({
        statistics: [{:beanstack_profile_id=>101, :first_name=>"Avery", :books=>12, :minutes=>300, :sessions=>2500, :pages=>25}, {:beanstack_profile_id=>102, :first_name=>"Dave", :books=>1, :minutes=>60, :sessions=>2, :pages=>50}, {:beanstack_profile_id=>103, :first_name=>"Robert", :books=>3, :minutes=>120, :sessions=>5, :pages=>100}],
        earned_badges: []
      })

    end

    stream_json({
      statistics: [{:beanstack_profile_id=>101, :first_name=>"Avery", :books=>12, :minutes=>300, :sessions=>2500, :pages=>25}, {:beanstack_profile_id=>102, :first_name=>"Dave", :books=>1, :minutes=>60, :sessions=>2, :pages=>50}, {:beanstack_profile_id=>103, :first_name=>"Robert", :books=>3, :minutes=>120, :sessions=>5, :pages=>100}],
      earned_badges: [{"id"=>nil, "profile_id"=>nil, "badge_id"=>nil, "created_at"=>nil, "updated_at"=>nil, "reward_id"=>nil, "microsite_id"=>nil, "library_branch_id"=>nil, "earnable_type"=>"Program", "earnable_id"=>12989, "program_id"=>12989, "profile_weight"=>1, "badge_type"=>"registration"}, {"id"=>nil, "profile_id"=>nil, "badge_id"=>nil, "created_at"=>nil, "updated_at"=>nil, "reward_id"=>nil, "microsite_id"=>nil, "library_branch_id"=>nil, "earnable_type"=>"Program", "earnable_id"=>12989, "program_id"=>12989, "profile_weight"=>1, "badge_type"=>"registration"}]
    })

    #SUCCESS SUCCESS_NO_EARNED_BADGES

  end

  def stream_json(data)
    stream partial: "integration/response", locals: {data: data}
  end

  def invalid_login_params?
    begin
      ['cable_auth', 'epic_account', 'current_beanstack_profile_id'].each do |k|
        raise "Required parameter was not passed: params['#{k}']" unless params.key?(k)
      end
      ['encrypted_data', 'user_id'].each do |k|
        raise "Required parameter was not passed: params['cable_auth']['#{k}']" unless params['cable_auth'].key?(k)
      end
    rescue Exception => e
      # Only happens if bad arguments.
      stream_json({
        message: 'Unspecified error.',
        exception_message: e.message,
        type: 'LOGIN_EXCEPTION'
      })
      return true
    end
    return false
  end

end
