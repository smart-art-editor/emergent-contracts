import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";
import { parseEther } from "viem";



const WorkspaceModule = buildModule("WorkspaceModule", (m) => {
  

  const org = m.contract("WorkSpace");


  return { org };
});

export default WorkspaceModule;
