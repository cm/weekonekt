(function(){

  Vue.$comp("busy");
  Vue.$comp("landing");

  Vue.$comp("main-counters", {
    data: {
      counters: [
        { label: "Locations", value: 241, icon: "map-marker" },
        { label: "Recommendations", value: 422, icon: "thumbs-up  " },
        { label: "Travellers", value: 131, icon: "smile-o" },
        { label: "Advertisers", value: 44, icon: "briefcase" }
      ]
    }
  });

  Vue.$comp("welcome-view");
  Vue.$comp("loading-view");

  Vue.$comp("top-locations");

  Vue.$comp("locationsearch", {
    states: {
      READY: {
        submit: {
          then: "BUSY"
        }
      },

      BUSY: {

      }
    }
  });

  Vue.$comp("locationresults");

  Vue.$comp("destinations");

  Vue.$comp("page-banner");
  Vue.$comp("page-header", {

  });

  Vue.$comp("page-footer", {
    data: {
      email: "marcos@weekonekt.com",
      street: "Bali, Indonesia",
      phone: "(+62) 811 399 88 09",
      appUrl: "http://demo.weekonekt.com"
    }
  });

  Vue.$comp("main", {
    ui: {
      content: {
        $DEFAULT: "welcome-view",
        SEARCHING_LOCATION: "destinations"
      }
    },

    states: {
      WELCOME: {
        searchingLocation: {
          then: "SEARCHING_LOCATION"
        }
      },
      SEARCHING_LOCATION: {

      }
    },
    listen: {
      states: {
        locationsearch: {
          BUSY: "searchingLocation"
        }
      }
    }
  });

  Vue.$app("app", {

  });

  Vue.$configure({
    verbose: true
  });

})();
