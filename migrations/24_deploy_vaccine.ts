//import dayjs from 'dayjs';

import { AdminRoleRegistryContract } from '../types/truffle-contracts/AdminRoleRegistry';
import { MedicalRoleRegistryContract } from '../types/truffle-contracts/MedicalRoleRegistry';
import { ManufacturerRoleRegistryContract } from '../types/truffle-contracts/ManufacturerRoleRegistry';
import { ShipperRoleRegistryContract } from '../types/truffle-contracts/ShipperRoleRegistry';

import { GateKeeperContract } from '../types/truffle-contracts/GateKeeper';
import {
  VaccineFactoryContract,
  VaccineFactoryInstance,
} from '../types/truffle-contracts/VaccineFactory';

import { VaccineRegistryContract } from '../types/truffle-contracts/VaccineRegistry';
import { deployStateMachineSystem } from './_helpers/provenance/statemachine';

const GateKeeper: GateKeeperContract = artifacts.require('GateKeeper');
const VaccineRegistry: VaccineRegistryContract = artifacts.require('VaccineRegistry');
const VaccineFactory: VaccineFactoryContract = artifacts.require('VaccineFactory');
const AdminRoleRegistry: AdminRoleRegistryContract = artifacts.require('AdminRoleRegistry');
const MedicalRoleRegistry: MedicalRoleRegistryContract = artifacts.require('MedicalRoleRegistry');
const ManufacturerRoleRegistry: ManufacturerRoleRegistryContract = artifacts.require('ManufacturerRoleRegistry');
const ShipperRoleRegistry: ShipperRoleRegistryContract = artifacts.require('ShipperRoleRegistry');


// eslint-disable-next-line @typescript-eslint/no-var-requires
const { enabledFeatures, storeIpfsHash } = require('../../truffle-config.js'); // two dirs up, because it is compiled into ./dist/migrations

module.exports = async (deployer: Truffle.Deployer, network: string, accounts: string[]) => {
  if (enabledFeatures().includes('VACCINE')) {
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const uiDefinitions = require('../../contracts/knowyourcustomer/UIDefinitions.json');

    const { factory } = await deployStateMachineSystem(
      deployer,
      accounts,
      GateKeeper,
      VaccineRegistry,
      VaccineFactory,
      [AdminRoleRegistry, ManufacturerRoleRegistry, ShipperRoleRegistry, MedicalRoleRegistry],
      uiDefinitions,
      storeIpfsHash
    );

    const Vaccines = [
      {
        vName: 'Pfizer',
        param2: '0x3ad941908e73d2214d08237e90cfce11cd490c16',
        doses: '100'
      },
      {
        vName: 'Astra Zeneca',
        param2: '0x3ad941908e73d2214d08237e90cfce11cd490c16',
        doses: '50'
      },
    ];
    for (const vaccine of Vaccines) {
      await createVaccine(factory, vaccine);
    }
  }
};

async function createVaccine(
  factory: VaccineFactoryInstance,
  vaccine: {
    vName: string;
    param2: string;
    doses: string;
  }

) {
  const ipfsHash = await storeIpfsHash({
     vName: vaccine.vName,
     param2: vaccine.param2,
     doses: vaccine.doses,
  });

  await factory.create(vaccine.vName, vaccine.param2, vaccine.doses, ipfsHash);
}
