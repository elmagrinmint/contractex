/**
 * Copyright (C) SettleMint NV - All Rights Reserved
 *
 * Use of this file is strictly prohibited without an active license agreement.
 * Distribution of this file, via any medium, is strictly prohibited.
 *
 * For license inquiries, contact hello@settlemint.com
 *
 * SPDX-License-Identifier: UNLICENSED
 */

pragma solidity ^0.8.0;

import '../_library//authentication/Secured.sol';
import '../_library//provenance/statemachine/StateMachine.sol';
import '../_library//utility/metadata/IpfsFieldContainer.sol';
import '../_library//utility/metadata/FileFieldContainer.sol';
import '../_library//utility/conversions/Converter.sol';

/**
 * Generic
 *
 * A generic package exists of
 *  - a description of the generic state machine
 *
 * @title Generic State machine implementation
 */
contract Vaccine is Converter, StateMachine, IpfsFieldContainer, FileFieldContainer {
  bytes32 public constant ORDER_CREATED = 'ORDER_CREATED';
  bytes32 public constant VACCINE_MANUFACTURED = 'VACCINE_MANUFACTURED';
  bytes32 public constant SHIPMENT_CREATED = 'SHIPMENT_CREATED';
  bytes32 public constant SHIPMENT_ACCEPTED = 'SHIPMENT_ACCEPTED';
  bytes32 public constant SHIPMENT_DECLINED = 'SHIPMENT_DECLINED';

  bytes32 public constant ROLE_ADMIN = 'ROLE_ADMIN';
  bytes32 public constant ROLE_SHIPPER = 'ROLE_SHIPPER';
  bytes32 public constant ROLE_MEDICAL = 'ROLE_MEDICAL';
  bytes32 public constant ROLE_MANUFACTURER = 'ROLE_MANUFACTURER';

  bytes32[] public _roles = [ROLE_ADMIN];

  string public _uiFieldDefinitionsHash;
  string private _vName;
  address _param2;
  uint256 private _doses;

  constructor(
    address gateKeeper,
    string memory vName,
    address param2,
    uint256 doses,
    string memory ipfsFieldContainerHash,
    string memory uiFieldDefinitionsHash
  ) Secured(gateKeeper) {
    _vName = vName;
    _param2 = param2;
    _doses = doses;
    _ipfsFieldContainerHash = ipfsFieldContainerHash;
    _uiFieldDefinitionsHash = uiFieldDefinitionsHash;
    setupStateMachine();
  }

  /**
   * @notice Updates state machine properties
   * @param vName the first parameter of the state machine
   * @param param2 the second parameter of the state machine
   * @param doses the third parameter of the state machine
   * @param ipfsFieldContainerHash ipfs hash of vehicle metadata
   */
  function edit(
    string memory vName,
    address param2,
    uint256 doses,
    string memory ipfsFieldContainerHash
  ) public {
    _vName = vName;
    _param2 = param2;
    _doses = doses;
    _ipfsFieldContainerHash = ipfsFieldContainerHash;

  }

  /**
   * @notice Returns all the roles for this contract
   * @return bytes32[] array of raw bytes representing the roles
   */
  function getRoles() public view returns (bytes32[] memory) {
    return _roles;
  }

/*  bytes32 public constant ORDER_CREATED = 'ORDER_CREATED';
  bytes32 public constant VACCINE_MANUFACTURED = 'VACCINE_MANUFACTURED';
  bytes32 public constant SHIPMENT_CREATED = 'SHIPMENT_CREATED';
  bytes32 public constant SHIPMENT_ACCEPTED = 'SHIPMENT_ACCEPTED';
  bytes32 public constant SHIPMENT_DECLINED = 'SHIPMENT_DECLINED'
  
  
    bytes32 public constant ROLE_ADMIN = 'ROLE_ADMIN';
  bytes32 public constant ROLE_SHIPPER = 'ROLE_SHIPPER';
  bytes32 public constant ROLE_MEDICAL = 'ROLE_MEDICAL';
  bytes32 public constant ROLE_MANUFACTURER = 'ROLE_MANUFACTURER';
  
  */


  function setupStateMachine() internal override {
    //create all states
    createState(ORDER_CREATED);
    createState(VACCINE_MANUFACTURED);
    createState(SHIPMENT_CREATED);
    createState(SHIPMENT_ACCEPTED);
    createState(SHIPMENT_DECLINED);

    // add properties
    // STATE_ONE
    addNextStateForState(ORDER_CREATED, VACCINE_MANUFACTURED);
    addRoleForState(ORDER_CREATED, ROLE_ADMIN);
    addRoleForState(ORDER_CREATED, ROLE_MANUFACTURER);

    // STATE_TWO
    addNextStateForState(VACCINE_MANUFACTURED, SHIPMENT_CREATED);
    addRoleForState(VACCINE_MANUFACTURED, ROLE_ADMIN);
    addRoleForState(VACCINE_MANUFACTURED, ROLE_SHIPPER);

    // STATE_THREE
    addNextStateForState(SHIPMENT_CREATED, SHIPMENT_ACCEPTED);
    addNextStateForState(SHIPMENT_CREATED, SHIPMENT_DECLINED);
    addRoleForState(SHIPMENT_CREATED, ROLE_ADMIN);
    addRoleForState(SHIPMENT_CREATED, ROLE_MEDICAL);

    setInitialState(ORDER_CREATED);
  }
}
