(function(){

  Vue.$comp("busy");
  Vue.$comp("landing");

  Vue.$comp("main-counters", {
    data: {
      counters: [
        { label: "Locations", value: 241, icon: "map-marker" },
        { label: "Recommendations", value: 422, icon: "comment-o" },
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

  Vue.$comp("destinationresults", {
    data: {
      continents: [
        { name: "Asia",
          picture: "cities-big-01",
          locations: [
            { name: "Bali",
              country: "Indonesia",
              picture: "cities-sm-01",
              count: 17
            },
            { name: "Bangkok",
              country: "Thailand",
              picture: "cities-sm-01",
              count: 215
            },
            { name: "Phu Ket",
              country: "Thailand",
              picture: "cities-sm-01",
              count: 2
            }
          ]
        },

      ]
    }
  });

  Vue.$comp("continentresult", {
    props: [ "continent" ]
  });

  Vue.$comp("locationresult", {
    many: true,
    props: [ "location" ],
    states: {
      DEFAULT: {
        select: {
          then: "DEFAULT",
          and: {
            send: "location",
            to: "main",
            data: "location.id"
          }
        }
      }
    }
  });


  Vue.$comp("destinations");
  Vue.$comp("categories", {
    data: {
      categories: [
        { name: "Accomodation",
          description: "Hotels, appartments, B&Bs...",
          options: [
            { name: "Type",
              choices: [
                { name: "Cottage" },
              ]
            },
            { name: "Rating",
              choices: [
                { name: "Mid-range" },
              ]
            }
          ]
        },
        { name: "Activities",
          description: "Sightseeing, sports, guided tours..."
        },
        { name: "Health",
          description: "Spas, well-being, relaxation..."
        },
        { name: "Food & Beverage",
          description: "Restaurants, Bars, pubs, lounges..."
        }

      ]
    }
  });

  Vue.$comp("recommendations" );
  
  Vue.$comp("categoryresult", {
    many: true,
    props: [ "category" ]
  });

  Vue.$comp("categoryoption", {
    many: true,
    props: [ "option" ]
  });

  Vue.$comp("optionchoice", {
    many: true,
    props: [ "choice" ]
  });

  Vue.$comp("page-banner");

  Vue.$comp("page-header", {
    ui: {
      navBarStyle: {
        $DEFAULT: "",
        LIGHT: "static-light"
      }
    },
    states: {
      DEFAULT: {
        light: {
          then: "LIGHT"
        }
      },

      LIGHT: {
        default: {
          then: "DEFAULT"
        }
      }
    },

    listen: {
      states: {
        main: {
          DESTINATIONS: "light",
          WELCOME: "default"
        }
      }
    }
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
        DESTINATIONS: "destinations",
        CATEGORIES: "categories"


      }
    },

    states: {
      WELCOME: {
        destinations: {
          then: "DESTINATIONS"
        }
      },
      DESTINATIONS: {
        location: {
          then: "CATEGORIES"
        }
      },
      CATEGORIES: {


      }

    },
    listen: {
      states: {
        locationsearch: {
          BUSY: "destinations"
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
