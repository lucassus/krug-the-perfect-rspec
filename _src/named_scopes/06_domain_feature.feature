Feature: User#unsubscribed_products

  Background:
    Given the following products exists
      | product          | active |
      | first product    | true   |
      | second product   | true   |
      | third product    | true   |
      | fourth product   | true   |
      | inactive product | false  |

    And the following users exists
      | user        |
      | first user  |
      | second user |
      | third user  |

  Scenario Outline: When the user has no active subscriptions it should return all active products
    Given the user "<user>" has no active subscriptions

    Then #unsubscribed_products for the user "<user>" should contain all active products
    And #unsubscribed_products for the user "<user>" should contain the following products:
      | product                  |
      | product "first product"  |
      | product "second product" |
      | product "third product"  |
      | product "fourth product" |

    And #unsubscribed_products for the user "<user>" should not contain the following products:
      | product                    |
      | product "inactive product" |

  Examples:
      | user        |
      | first user  |
      | second user |
      | third user  |

  Scenario Outline: When the user has several active subscriptions it should return list with active products without active subscriptions
    Given the active subscription exists with user: user "<user>", product: product "first product"
    And the active subscription exists with user: user "<user>", product: product "third product"
    And the cancelled subscription exists with user: user "<user>", product: product "third product"

    Then #unsubscribed_products for the user "<user>" should contain the following products:
      | product                  |
      | product "second product" |
      | product "fourth product" |

    Then #unsubscribed_products for the user "<user>" should not contain the following products:
      | product                    |
      | product "first product"    |
      | product "third product"    |
      | product "inactive product" |

  Examples:
      | user        |
      | first user  |
      | second user |
      | third user  |

  Scenario Outline: When the user has several cancelled subscriptions it should return list with active products without active subscriptions
    Given the cancelled subscription exists with user: user "<user>", product: product "first product"
    And the cancelled subscription exists with user: user "<user>", product: product "second product"

    And the subscription exists with user: user "<user>", product: product "third product"
    And the cancelled subscription exists with user: user "<user>", product: product "third product"

    Then #unsubscribed_products for the user "<user>" should contain the following products:
      | product                  |
      | product "first product"  |
      | product "second product" |
      | product "fourth product" |

    Then #unsubscribed_products for the user "<user>" should not contain the following products:
      | product                    |
      | product "third product"    |
      | product "inactive product" |

  Examples:
      | user        |
      | first user  |
      | second user |
      | third user  |

  Scenario: It should return list of products available for the user
    Given the following subscriptions exists
      | user              | product                  | status    |
      | user "first user" | product "first product"  | active    |
      | user "first user" | product "second product" | cancelled |
      | user "first user" | product "fourth product" | active    |

    Then #unsubscribed_products for the user "first user" should contain the following products:
      | product                  |
      | product "second product" |
      | product "third product"  |
    And #unsubscribed_products for the user "second user" should contain all active products
    And #unsubscribed_products for the user "third user" should contain all active products

    When the user "first user" cancel his subscription for product "first product"
    Then #unsubscribed_products for the user "first user" should contain the following products:
      | product                  |
      | product "first product"  |
      | product "second product" |
      | product "third product"  |

    When the user "first user" cancel his subscription for product "fourth product"
    And #unsubscribed_products for the user "first user" should contain all active products

    When I disable the product "third product"
    Then #unsubscribed_products for the user "first user" should contain the following products:
      | product                  |
      | product "first product"  |
      | product "second product" |
      | product "fourth product" |
    Then #unsubscribed_products for the user "first user" should not contain the following products:
      | product                    |
      | product "third product"    |
      | product "inactive product" |

    When a subscription exists with user: user "first user", product: product "fourth product"
    Then #unsubscribed_products for the user "first user" should contain the following products:
      | product                  |
      | product "first product"  |
      | product "second product" |

