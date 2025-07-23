import Head from "next/head";
import { CardanoWallet, MeshBadge } from "@meshsdk/react";

const onWalletConnectHandler = () => {
  console.log("wallet connected");
};

export default function Home() {
  return (
    <div className="bg-gray-900 w-full text-white text-center">
      <Head>
        <title>MintForge</title>
        <meta name="description" content="MintForge on the Cardano Blockchain" />
      </Head>
      <main
        className={`flex min-h-screen flex-col items-center justify-center p-24`}
      >

        <h1 className="text-6xl font-thick mb-20">
          MintForge
        </h1>

        <div className="mb-20">
          <CardanoWallet
            label={"Connect a wallet"}
            onConnected={onWalletConnectHandler}
            isDark={false}
          />
        </div>
     </main>
    </div>
  );
}
