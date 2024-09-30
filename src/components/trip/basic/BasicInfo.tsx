import {Trip} from "../../../types/trips.ts";
import {Container, Flex} from "@mantine/core";
import {QueryObserverResult, RefetchOptions, Register} from "@tanstack/react-query";
import {BasicInfoView} from "./BasicInfoView.tsx";
import {BasicInfoMenu} from "./BasicInfoMenu.tsx";

export const BasicInfo = ({trip, refetch}: {
  trip: Trip,
  refetch: (options?: RefetchOptions) => Promise<QueryObserverResult<Trip, Register extends {
    defaultError: infer TError
  } ? TError : Error>>
}) => {

  return (
    <Container py={"xs"} size="lg">
      <Flex
        mih={50}
        gap="md"
        justify="flex-end"
        align="center"
        direction="row"
        wrap="wrap"
      >
        <BasicInfoMenu trip={trip} refetch={refetch} />
      </Flex>
      <BasicInfoView trip={trip} refetch={refetch}/>
    </Container>
  )
}