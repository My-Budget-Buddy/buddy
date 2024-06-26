export interface Repository {
  /** The github URL */
  url: string;

  /** The branch containing most stable/up-to-date code */
  branch: string;

  /** The root directory of the source code */
  rootDir: string;

  /** The name of the service in the compose.yml */
  serviceName: string;

  /** Whether this service is required (gateway, eureka, auth? in the future) */
  default?: boolean;

  /** The port that this service will run on */
  port: number;
}

export const repositories: Repository[] = [
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-AccountService",
    branch: "main",
    rootDir: "",
    serviceName: "accounts",
    port: 8080,
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-UserService",
    branch: "main",
    rootDir: "",
    serviceName: "users",
    port: 8081,
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-BudgetService",
    branch: "main",
    rootDir: "/budget-service",
    serviceName: "budgets",
    port: 8082,
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-TransactionService",
    branch: "main",
    rootDir: "",
    serviceName: "transactions",
    port: 8083,
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-TaxService",
    branch: "main",
    rootDir: "",
    serviceName: "tax",
    port: 8084,
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-CreditScoreService",
    branch: "main",
    rootDir: "",
    serviceName: "credit-score",
    port: 8085,
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-GatewayService",
    branch: "main",
    rootDir: "",
    serviceName: "gateway",
    default: true,
    port: 8125,
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-DiscoveryService",
    branch: "main",
    rootDir: "",
    serviceName: "eureka",
    default: true,
    port: 8761,
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-AuthService",
    branch: "main",
    rootDir: "",
    serviceName: "auth",
    default: true,
    port: 8888,
  },
];
