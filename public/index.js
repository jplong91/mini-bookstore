/* global Vue, VueRouter, axios */

var HomePage = {
  template: "#home-page",
  data: function() {
    return {
      books: []
    };
  },
  mounted: function() {
    axios.get("v1/books").then(
      function(response) {
        this.books = response.data;
      }.bind(this)
    );
  },
  methods: {},
  computed: {}
};

var BookPage = {
  template: "#book-page",
  data: function() {
    return {
      book: []
    };
  },
  mounted: function() {
    axios
      .get("/v1/books/" + this.$route.params.id)
      .then(
        function(response) {
          this.book = response.data;
        }.bind(this)
      )
      .catch(function(error) {
        console.log(error);
      });
  },
  methods: {},
  computed: {}
};

var NewBook = {
  template: "#new-book",
  data: function() {
    return {
      title: "",
      author: "",
      price: null,
      pages: null,
      publisherId: null,
      errors: []
    };
  },
  // mounted: function() {
  //   $(".collapse").collapse("hide");
  // },
  methods: {
    submit: function() {
      var params = {
        title: this.title,
        author: this.author,
        price: this.price,
        pages: this.pages,
        publisher_id: this.publisherId
      };
      axios
        .post("/v1/books", params)
        .then(function(response) {
          console.log(response);
          router.push("/#/");
        })
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
          }.bind(this)
        );
    }
  }
};

var EditBook = {
  template: "#edit-book",
  data: function() {
    return {
      book: [],
      title: "",
      author: "",
      price: null,
      pages: null,
      publisherId: null,
      errors: []
    };
  },
  mounted: function() {
    axios
      .get("/v1/books/" + this.$route.params.id)
      .then(
        function(response) {
          console.log(response);
          this.book = response.data;
        }.bind(this)
      )
      .catch(function(error) {
        console.log(error);
      });
  },
  methods: {
    submit: function() {
      var params = {
        title: this.title,
        author: this.author,
        price: this.price,
        pages: this.pages,
        publisher_id: this.publisherId
      };
      axios
        .patch("/v1/books/" + this.book.id, params)
        .then(
          function(response) {
            router.push("/books/" + this.book.id);
          }.bind(this)
        )
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
          }.bind(this)
        );
    }
  }
};

var SignupPage = {
  template: "#signup-page",
  data: function() {
    return {
      name: "",
      email: "",
      password: "",
      passwordConfirmation: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        name: this.name,
        email: this.email,
        password: this.password,
        password_confirmation: this.passwordConfirmation
      };
      axios
        .post("/v1/users", params)
        .then(function(response) {
          router.push("/login");
        })
        .catch(
          function(error) {
            this.errors = error.response.data.errors;
          }.bind(this)
        );
    }
  }
};

var LoginPage = {
  template: "#login-page",
  data: function() {
    return {
      email: "",
      password: "",
      errors: []
    };
  },
  methods: {
    submit: function() {
      var params = {
        auth: { email: this.email, password: this.password }
      };
      axios
        .post("/user_token", params)
        .then(function(response) {
          axios.defaults.headers.common["Authorization"] =
            "Bearer " + response.data.jwt;
          localStorage.setItem("jwt", response.data.jwt);
          router.push("/");
        })
        .catch(
          function(error) {
            this.errors = ["Invalid email or password."];
            this.email = "";
            this.password = "";
          }.bind(this)
        );
    }
  }
};

var LogoutPage = {
  mounted: function() {
    axios.defaults.headers.common["Authorization"] = undefined;
    localStorage.removeItem("jwt");
    router.push("/");
  }
};

var router = new VueRouter({
  routes: [
    { path: "/", component: HomePage },
    { path: "/books/new", component: NewBook },
    { path: "/books/:id", component: BookPage },
    { path: "/signup", component: SignupPage },
    { path: "/login", component: LoginPage },
    { path: "/logout", component: LogoutPage },
    { path: "/books/edit/:id", component: EditBook }
  ],
  scrollBehavior(to, from, savedPosition) {
    return { x: 0, y: 0 };
  }
});

var app = new Vue({
  el: "#app",
  router: router,
  created: function() {
    var jwt = localStorage.getItem("jwt");
    if (jwt) {
      axios.defaults.headers.common["Authorization"] = jwt;
    }
  }
});
