module addrx::erebrus{
    use sui::object::{Self,ID,UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use std::string::String;
    use sui::event;
    use sui::coin::{Self, Coin};
    use sui::balance::{Self,Balance};
    use sui::sui::SUI;

    struct NFT has key,store {
        id: UID,
        name: String,
        description: String,
        url: String,
    }

    struct Funds has key,store {
        id: UID,
        raised: Balance<SUI>,
    }

    struct Admin has key { id: UID }

    /**************** Event Struct **********************/
    struct NFTMinted has copy, drop {
        // The Object ID of the NFT
        object_id: ID,
        // The creator of the NFT
        creator: address,
        // The name of the NFT
        name: String,
    }

    


    fun init(ctx: &mut TxContext){
        transfer::share_object(Funds{
                id: object::new(ctx),
                raised: balance::zero(),
           }    
        );

        transfer::transfer(Admin{id: object::new(ctx)},tx_context::sender(ctx))
    }

    public entry fun mint(
        nft_name: String, 
        nft_description: String, 
        nft_url: String,
        amount: Coin<SUI>, 
        fund: &mut Funds,
        ctx: &mut TxContext
    ){
        let sender = tx_context::sender(ctx);
        let coin_balance = coin::into_balance(amount);
        balance::join(&mut fund.raised,coin_balance);
                
        let nft = NFT {
            id: object::new(ctx),
            name: nft_name,
            description: nft_description,
            url: nft_url,
        };

        
        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });
        
        transfer::public_transfer(nft, sender);

    }


    entry fun withdraw(_: &Admin,funds: &mut Funds, ctx: &mut TxContext){
        let amount = balance::value(&funds.raised);
        let obj_raised = coin::take(&mut funds.raised, amount, ctx);
        transfer::public_transfer(obj_raised,tx_context::sender(ctx));
    }

}