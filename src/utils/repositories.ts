export interface Repository {
  url: string;
  branch: string;
  rootDir: string;
  outputDir?: string;
}

export const repositories: Repository[] = [
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-AccountService",
    branch: "main",
    rootDir: "",
    outputDir: "accounts",
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-AuthService",
    branch: "main",
    rootDir: "",
    outputDir: "auth",
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-BudgetService",
    branch: "develop",
    rootDir: "/budget-service",
    outputDir: "budgets",
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-TaxService",
    branch: "main",
    rootDir: "",
    outputDir: "tax",
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-UserService",
    branch: "main",
    rootDir: "",
    outputDir: "users",
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-TransactionService",
    branch: "main",
    rootDir: "",
    outputDir: "transactions",
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-GatewayService",
    branch: "main",
    rootDir: "",
    outputDir: "gateway",
  },
  {
    url: "https://github.com/My-Budget-Buddy/Budget-Buddy-DiscoveryService",
    branch: "main",
    rootDir: "",
    outputDir: "eureka",
  },
];
