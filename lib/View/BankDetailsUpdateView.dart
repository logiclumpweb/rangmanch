

import 'package:champcash/Apis/api.dart';
import 'package:champcash/Data/UserData.dart';
import 'package:champcash/models/BankDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../shared/extras.dart';
import '../shared/textfields.dart';

class BankdetailsUpdate extends StatefulWidget {
  const BankdetailsUpdate({Key? key}) : super(key: key);

  @override
  State<BankdetailsUpdate> createState() => _BankdetailsUpdateState();
}

class _BankdetailsUpdateState extends State<BankdetailsUpdate> {

    var editNameController = TextEditingController();
    var editBankNameController = TextEditingController();
    var editIFSCController = TextEditingController();
    var editAccountNumberController = TextEditingController();
    var editBranchController = TextEditingController();

   bool isUpdated=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var hashMap={
      "user_id":userLoginModel!.data.userId,
    };
    getBankDetailsApi(hashMap).then((value) {

      if(value.status){
        isUpdated=false;
        BankDetailsModel model=value.data;
        userbankDetailsModel=model;
        if(userbankDetailsModel!=null){
          setState(() {
            editBranchController.text=userbankDetailsModel!.data.branchName;
            editAccountNumberController.text=userbankDetailsModel!.data.accountNumber;
            editBankNameController.text=userbankDetailsModel!.data.bankName;
            editIFSCController.text=userbankDetailsModel!.data.ifscCode;
            editNameController.text=userbankDetailsModel!.data.userName;
          });

        }else{
          showErrorBottomSheet(value.message.toString());
        }
      }else{
        setState(() {
          isUpdated=true;
        });
      }

    });
  }


  @override
  Widget build(BuildContext context) {
   return SACellGradientContainer(child:SafeArea(
      child: Stack(
        children: [

          Column(children: [
            iAPPBARUI(),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                   ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(children: [
                        addPadding(0, 5),
                        Padding(
                          padding: const EdgeInsets.only(top:20.0,left: 20,right: 20),
                          child: TextFormField(decoration: InputDecoration(hintText: "Name"),keyboardType: TextInputType.name,controller: editNameController,
                            enabled: isUpdated,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:25.0,left: 20,right: 20),
                          child: TextFormField(decoration: InputDecoration(hintText: "Bank Name"),keyboardType: TextInputType.name,controller:editBankNameController,
                            enabled:isUpdated,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:20.0,left: 20,right: 20),
                          child: TextFormField(decoration: InputDecoration(hintText: "IFSC",),controller: editIFSCController,
                            enabled: isUpdated,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:25.0,left: 20,right: 20),
                          child: TextFormField(decoration: InputDecoration(hintText: "Account Number"),keyboardType: TextInputType.number,controller:editAccountNumberController,
                            enabled: isUpdated,),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top:25.0,left: 20,right: 20),
                          child: TextFormField(decoration: InputDecoration(hintText: "Branch"),keyboardType: TextInputType.name,controller:editBranchController,
                            enabled: isUpdated,),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top:5.0,left: 20,right: 20),
                          child: Divider(height: 3,color: Color(0xffe9e9ea),),
                        ),


                      ],),
                    ),
                   isUpdated? Padding(
                      padding: const EdgeInsets.only(top:10.0,left: 20,right: 20,bottom: 30),
                      child: GradientButton1(text: "SAVE", onPressed: (){
                        if(validation()) {
                          saveBankDetailsAPIs();
                        }
                      }),
                    ):SizedBox()
                  ],
                ),
              ),
            )

          ],),
        ],
      ),
    ));
  }
  bool validation() {
    if(editNameController.text.trim().isEmpty){
      showErrorBottomSheet("Please enter name.");
      return false;
    }

    if(editBankNameController.text.trim().isEmpty){
      showErrorBottomSheet("Please enter Bank Name.");
      return false;
    }

    if(editIFSCController.text.trim().isEmpty){
      showErrorBottomSheet("Please enter IFSC number.");
      return false;
    }

    if(editAccountNumberController.text.trim().isEmpty){
      showErrorBottomSheet("Please enter Account number.");
      return false;
    }
    if(editBranchController.text.trim().isEmpty){
      showErrorBottomSheet("Please enter Branch.");
      return false;
    }

    return true;
  }

    iAPPBARUI() {
      return AppBar(
        backgroundColor: ColorConstants.APPPRIMARYCOLOR,
        title: headingText(title: "Update Bank Details", fontSize: 16),
      );
    }


  void saveBankDetailsAPIs() {
    var hashMap={
      "bank_user_name":editNameController.text.trim(),
      "user_id":userLoginModel!.data.userId,
      "bank_name":editBankNameController.text.trim(),
      "ifsc_code":editIFSCController.text.trim(),
      "account_number":editAccountNumberController.text.trim(),
      "branch_name":editBranchController.text.trim(),
    };
    print(hashMap);
    SaveBankDetailsApi(hashMap).then((value) {
      if(value.status){
        toastMessage(value.message);

      }else{
        toastMessage(value.message);
      }
    });

  }
}
