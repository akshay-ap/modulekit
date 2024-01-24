// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { RhinestoneAccount, UserOpData } from "./RhinestoneModuleKit.sol";
import { UserOperation, IEntryPoint } from "../external/ERC4337.sol";
import { IERC7579Account, IERC7579ConfigHook } from "../external/ERC7579.sol";
import { ModuleKitUserOp, UserOpData } from "./ModuleKitUserOp.sol";
import { ERC4337Helpers } from "./utils/ERC4337Helpers.sol";
import { ModuleKitCache } from "./utils/ModuleKitCache.sol";
import { writeExpectRevert, writeGasIdentifier } from "./utils/Log.sol";

library ModuleKitHelpers {
    using ModuleKitUserOp for RhinestoneAccount;
    using ModuleKitHelpers for RhinestoneAccount;
    using ModuleKitHelpers for UserOpData;

    // will call installValidator with initData:0

    function execUserOps(UserOpData memory userOpData) internal {
        // send userOp to entrypoint

        IEntryPoint entrypoint = ModuleKitCache.getEntrypoint(userOpData.userOp.sender);
        ERC4337Helpers.exec4337(userOpData.userOp, entrypoint);
    }

    function signDefault(UserOpData memory userOpData) internal pure returns (UserOpData memory) {
        userOpData.userOp.signature = "DEFAULT SIGNATURE";
        return userOpData;
    }

    function installValidator(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (UserOpData memory userOpData)
    {
        return instance.installValidator(module, "");
    }

    function installValidator(
        RhinestoneAccount memory instance,
        address module,
        bytes memory initData
    )
        internal
        returns (UserOpData memory userOpData)
    {
        userOpData =
            instance.getInstallValidatorOps(module, initData, address(instance.defaultValidator));
        // sign userOp with default signature
        userOpData = userOpData.signDefault();
        // send userOp to entrypoint
        userOpData.execUserOps();
    }

    // will call uninstallValidator with initData:0
    function uninstallValidator(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (UserOpData memory userOpData)
    {
        return instance.uninstallValidator(module, "");
    }
    // will call uninstallValidator with initData:0

    function uninstallValidator(
        RhinestoneAccount memory instance,
        address module,
        bytes memory initData
    )
        internal
        returns (UserOpData memory userOpData)
    {
        userOpData =
            instance.getUninstallValidatorOps(module, initData, address(instance.defaultValidator));

        // sign userOp with default signature
        userOpData = userOpData.signDefault();
        // send userOp to entrypoint
        userOpData.execUserOps();
    }
    // will call installValidator with initData:0

    function installExecutor(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (UserOpData memory userOpData)
    {
        return instance.installExecutor(module, "");
    }

    // will call installValidator with initData:0
    function installExecutor(
        RhinestoneAccount memory instance,
        address module,
        bytes memory initData
    )
        internal
        returns (UserOpData memory userOpData)
    {
        userOpData =
            instance.getInstallExecutorOps(module, initData, address(instance.defaultValidator));

        // sign userOp with default signature
        userOpData = userOpData.signDefault();
        // send userOp to entrypoint
        userOpData.execUserOps();
    }

    function uninstallExecutor(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (UserOpData memory userOpData)
    {
        return instance.uninstallExecutor(module, "");
    }

    // will call uninstallExecutor with initData:0
    function uninstallExecutor(
        RhinestoneAccount memory instance,
        address module,
        bytes memory initData
    )
        internal
        returns (UserOpData memory userOpData)
    {
        userOpData =
            instance.getUninstallExecutorOps(module, initData, address(instance.defaultValidator));

        // sign userOp with default signature
        userOpData = userOpData.signDefault();
        // send userOp to entrypoint
        userOpData.execUserOps();
    }

    function installHook(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (UserOpData memory userOpData)
    {
        return instance.installHook(module, "");
    }
    // executes installHook with initData:0

    function installHook(
        RhinestoneAccount memory instance,
        address module,
        bytes memory initData
    )
        internal
        returns (UserOpData memory userOpData)
    {
        userOpData =
            instance.getInstallHookOps(module, initData, address(instance.defaultValidator));

        // sign userOp with default signature
        userOpData = userOpData.signDefault();
        // send userOp to entrypoint
        userOpData.execUserOps();
    }

    // executes uninstallHook with initData:0
    function uninstallHook(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (UserOpData memory userOpData)
    {
        userOpData = instance.getUninstallHookOps(module, "", address(instance.defaultValidator));
        // sign userOp with default signature
        userOpData = userOpData.signDefault();
        // send userOp to entrypoint
        userOpData.execUserOps();
    }

    // executes installFallback with initData:0
    function installFallback(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (UserOpData memory userOpData)
    {
        userOpData = instance.getInstallFallbackOps(module, "", address(instance.defaultValidator));
        // sign userOp with default signature
        userOpData = userOpData.signDefault();
        // send userOp to entrypoint
        userOpData.execUserOps();
    }

    // executes installFallback wiith initData:0
    function uninstallFallback(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (UserOpData memory userOpData)
    {
        userOpData = instance.getInstallFallbackOps(module, "", address(instance.defaultValidator));
        // sign userOp with default signature
        userOpData = userOpData.signDefault();
        // send userOp to entrypoint
        userOpData.execUserOps();
    }

    function exec(
        RhinestoneAccount memory instance,
        address target,
        uint256 value,
        bytes memory callData
    )
        internal
        returns (UserOpData memory userOpData)
    {
        userOpData =
            instance.getExecOps(target, value, callData, address(instance.defaultValidator));
        // sign userOp with default signature
        userOpData = userOpData.signDefault();
        // send userOp to entrypoint
        userOpData.execUserOps();
    }

    function exec(
        RhinestoneAccount memory instance,
        address target,
        bytes memory callData
    )
        internal
        returns (UserOpData memory userOpData)
    {
        return exec(instance, target, 0, callData);
    }

    function isValidatorInstalled(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (bool)
    {
        return IERC7579Account(instance.account).isValidatorInstalled(module);
    }

    function isExecutorInstalled(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (bool)
    {
        return IERC7579Account(instance.account).isExecutorInstalled(module);
    }

    function isHookInstalled(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (bool)
    {
        return IERC7579ConfigHook(instance.account).isHookInstalled(module);
    }

    function isFallbackInstalled(
        RhinestoneAccount memory instance,
        address module
    )
        internal
        returns (bool)
    {
        return IERC7579Account(instance.account).isFallbackInstalled(module);
    }

    function expect4337Revert(RhinestoneAccount memory) internal {
        writeExpectRevert(1);
    }

    /**
     * @dev Logs the gas used by an ERC-4337 transaction
     * @dev needs to be called before an exec4337 call
     * @dev the id needs to be unique across your tests, otherwise the gas calculations will
     * overwrite each other
     *
     * @param instance RhinestoneAccount
     * @param id Identifier for the gas calculation, which will be used as the filename
     */
    function log4337Gas(RhinestoneAccount memory instance, string memory id) internal {
        writeGasIdentifier(id);
    }
}
