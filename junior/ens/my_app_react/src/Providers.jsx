import { createWeb3Modal } from "@web3modal/wagmi/react";
import { defaultWagmiConfig } from "@web3modal/wagmi/react/config";
import { sepolia } from "wagmi/chains";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { WagmiProvider } from "wagmi";

// 0. Setup queryClient
const queryClient = new QueryClient();

// 1. Get projectId at https://cloud.walletconnect.com
const projectId = import.meta.env.VITE_REACT_WALLET_CONNECT_PROJECT_ID;

const metadata = {
  name: "ens dApp",
  description: "ens dApp",
  url: "https://web3modal.com", // origin must match your domain & subdomain
  icons: [
    "https://avatars.githubusercontent.com/u/72856939?s=400&u=ef3d4c1e0b82b1e7ba94770b9d9c2d2fa4a5e69d&v=4",
  ],
};

const config = defaultWagmiConfig({
  appName: import.meta.env.VITE_REACT_APP_NAME,
  projectId,
  metadata,
  chains: [sepolia],
});

// 3. Create modal
createWeb3Modal({
  wagmiConfig: config,
  projectId,
  enableAnalytics: true, // Optional - defaults to your Cloud configuration
  enableOnramp: true, // Optional - false as default
});

export default function Providers({ children }) {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>{children}</QueryClientProvider>
    </WagmiProvider>
  );
}
