// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts
 */
contract Campaign {

    struct record {
        uint scr; // 1 is hourly, 2 is daily, 3 is weekly, 4 is monthly
        uint ts; 
    }

    address ADMIN = 0xD0DC8A261Ad1B75a92C5E502ae10c3Fde042b000;
    mapping (string => record) public scores;
    mapping (uint => address) public best;
    mapping (uint => uint) public bestscores;

    
    function register(uint score, uint game) public {
        string memory b = string.concat(Strings.toHexString(uint256(uint160(msg.sender)), 20), Strings.toString(game));
        record storage r = scores[b]; 
        if (r.scr < score){
            record memory s = record({
                scr: score,
                ts: block.timestamp
            });
            scores[b] = s;
            if (bestscores[game] < score){
                bestscores[game] = score;
                best[game] = msg.sender;
            }
        }
    }

    
    function fetch_best(uint gid) public view returns (address){
        address bst = best[gid];
        return bst;
    }

    function fetch_bestscore(uint gid) public view returns (uint){
        uint bstscr = bestscores[gid];
        return bstscr;
    }

    
}
