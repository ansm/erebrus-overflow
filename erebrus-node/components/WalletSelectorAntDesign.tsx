import { WalletSelector } from "@aptos-labs/wallet-adapter-ant-design";
import { useEffect } from 'react';

const WalletSelectorAntDesign = () => {

  useEffect(() => {
    // Find the button element
    const button = document.querySelector('.wallet-button');
    if (button) {
      // Set the new text
      button.textContent = 'Get Started';
    }
  }, []);

  return <WalletSelector />;
};

export default WalletSelectorAntDesign;