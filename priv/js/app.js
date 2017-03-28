(function(){
  
  Vue.$comp("busy");
  Vue.$comp("landing");


  Vue.$app("app", {
    ui: {
      content: {
        $DEFAULT: "landing",
        READY: "landing"
      }
    },  
    states: {
      DEFAULT: {
        init: { then: "READY" }
      },

      READY: {

      }
    },

    hooks: {
      $init: "init"
    }
  });

  Vue.$configure({
    verbose: true
  });

})();
